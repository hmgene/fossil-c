cat  ../../bigdata/augustus/Brachy_cells.gff  | grep -v "^#" | hm gff2bed12 -  | awk -v OFS="\t" '$10>2{$1="chr1";print $0;}' | head -n 100 > Brachy_cells_multi_exon.bed 



import torch
from evo2 import Evo2

evo2_model = Evo2('evo2_7b', device='cuda')
#evo2_model = Evo2('evo2_7b')

sequence = 'ACGT'
input_ids = torch.tensor(
    evo2_model.tokenizer.tokenize(sequence),
    dtype=torch.int,
).unsqueeze(0).to('cuda:0')

outputs, _ = evo2_model(input_ids)
logits = outputs[0]

print('Logits: ', logits)
print('Shape (batch, length, vocab): ', logits.shape)
