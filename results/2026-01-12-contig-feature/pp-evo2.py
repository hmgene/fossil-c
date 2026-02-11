import pandas as pd
from Bio import SeqIO
from Bio.Seq import Seq

FASTA="NODE_1191_length_51173_cov_85.760300.fa"
GFF="NODE_1191_length_51173_cov_85.760300.gff"

ORGANISM = "Unknown"
ASSEMBLY = "Unknown_assembly"
LABEL = 0

fasta = SeqIO.to_dict(SeqIO.parse(FASTA, "fasta"))

exons= []
with open(GFF) as f:
    for line in f:
        if line.startswith("#"):
            continue
        cols = line.strip().split("\t")
        if cols[2] != "CDS":
            continue
        #NODE_1191_length_51173_cov_85.760300	AUGUSTUS	gene	1	29167	1	+	.	g66864
        seqid, _, _, start, end, _, strand, _, gene_id = cols
        start, end = int(start), int(end)
        exons.append({ "sequence_record": seqid, "gene_name": gene_id, "start": start, "end": end, "strand": strand })

exons = pd.DataFrame(exons)

rows = []
for _, g in exons.iterrows():
    seq = fasta[g.sequence_record].seq
    gene_seq = seq[g.start - 1 : g.end]  # GFF is 1-based
    forward = gene_seq
    reverse = gene_seq.reverse_complement()
    rows.append({ "organism": ORGANISM, "assembly": ASSEMBLY, "gene_name": g.gene_name, "sequence_record": g.sequence_record,
        "strand": g.strand, "position": float(g.start), "label": float(LABEL), "forward_seq": str(forward).lower(), "reverse_seq": str(reverse).lower()
    })

positions = pd.DataFrame(rows)

# -----------------------
# evo2 run (https://github.com/ArcInstitute/evo2/blob/main/notebooks/exon_classifier/exon_classifier.ipynb) 
# -----------------------
from evo2 import Evo2
evo2_model = Evo2('evo2_7b_base')
import torch

# Function to tokenize and get embedding for the final token in a sequence
def get_final_token_embedding(sequence, model, layer_name):
    input_ids = torch.tensor(
        model.tokenizer.tokenize(sequence),
        dtype=torch.int,
    ).unsqueeze(0).to('cuda:0')
    with torch.no_grad():
        _, embeddings = model(input_ids, return_embeddings=True, layer_names=[layer_name])
    return embeddings[layer_name][0, -1, :].cpu().to(torch.float32).numpy()  # shape: (hidden_dim,)

# Get Evo 2 embeddings for the each position and append to the dataframe
import numpy as np
from tqdm import tqdm

embedding_list = []
layer_name = 'blocks.26'

for _, row in tqdm(positions.iterrows(), total=len(positions), desc="Extracting embeddings"):
    emb_fwd = get_final_token_embedding(row['forward_seq'], evo2_model, layer_name)
    emb_rev = get_final_token_embedding(row['reverse_seq'], evo2_model, layer_name)
    emb_concat = np.concatenate((emb_fwd, emb_rev))
    embedding_list.append(emb_concat)

# Add to DataFrame
positions['embedding'] = embedding_list


from transformers import AutoModel

exon_classifier = AutoModel.from_pretrained(
    "schmojo/evo2-exon-classifier",
    trust_remote_code=True   # pulls the two .py files
).to('cuda:0')
# Generate exonic probabilities for each sample position
exonic_probs_list = []

for _, row in tqdm(positions.iterrows(), total=len(positions), desc="Calculating exonic probabilities"):
    embedding_tensor = torch.tensor(row['embedding'], dtype=torch.float32).unsqueeze(0).unsqueeze(1).to('cuda:0')
    prob = exon_classifier(embedding_tensor)
    prob_value = prob['logits'].item()
    exonic_probs_list.append(prob_value)

# Add to DataFrame
positions['exon_prob'] = exonic_probs_list
# Plot ROC and display Accuracy (threshold=0.5) and AUROC
from sklearn.metrics import roc_auc_score, roc_curve, accuracy_score
import matplotlib.pyplot as plt

y_true = positions['label']
y_scores = positions['exon_prob']

# AUROC
auroc = roc_auc_score(y_true, y_scores)

# Accuracy at threshold 0.5
y_pred = (y_scores >= 0.5).astype(int)
accuracy = accuracy_score(y_true, y_pred)

# ROC curve
fpr, tpr, _ = roc_curve(y_true, y_scores)

# Plot
plt.figure(figsize=(6, 6))
plt.plot(fpr, tpr, label=f"AUROC = {auroc:.4f}\nAccuracy@0.5 = {accuracy:.4f}")
plt.plot([0, 1], [0, 1], linestyle='--', color='gray')  # Diagonal line
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.title("Receiver Operating Characteristic (ROC)")
plt.legend(loc='lower right')
plt.grid(True)
plt.savefig("roc.png")
plt.show()

