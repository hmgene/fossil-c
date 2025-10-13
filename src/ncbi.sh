
ncbi-dn-genome(){
python <( echo '
from Bio import Entrez
import os
import requests

Entrez.email = "your_email@example.com"

# List of species
species_list = [
    "Varanus komodoensis",   # Komodo dragon
    "Anolis sagrei",         # Brown anole
    "Pogona vitticeps",      # Bearded dragon
    "Struthio camelus",      # Common ostrich
    "Falco peregrinus"       # Peregrine falcon
]

out_dir = "genomes"
os.makedirs(out_dir, exist_ok=True)

def get_assembly_info(species_name):
    handle = Entrez.esearch(db="assembly", term=f"{species_name}[organism]", retmax=1)
    record = Entrez.read(handle)
    handle.close()
    ids = record["IdList"]
    if not ids:
        return None
    handle = Entrez.esummary(db="assembly", id=",".join(ids), report="full")
    summary = Entrez.read(handle)
    handle.close()
    doc = summary["DocumentSummarySet"]["DocumentSummary"][0]
    ftp_path = doc["FtpPath_RefSeq"] or doc["FtpPath_GenBank"]
    assembly_accession = doc["AssemblyAccession"]
    assembly_name = doc["AssemblyName"]
    taxid = doc["Taxid"]
    genome_file = f"{assembly_accession}_{assembly_name}_genomic.fna.gz"
    return {"species": species_name, "taxid": taxid, "ftp_path": ftp_path, "genome_file": genome_file }

def download_genome(finfo, out_dir="."):
    ftp_path = finfo["ftp_path"]
    species = finfo["species"]
    fasta_filename = finfo["genome_file"];

    fasta_url = f"{ftp_path}/{fasta_filename}"
    out_file = os.path.join(out_dir, fasta_filename)

    if os.path.exists(out_file):
        print(f"✅ Already downloaded: {out_file}")
        return out_file

    print(f"⬇️ Downloading {species} -> {out_file}")
    r = requests.get(fasta_url, stream=True)
    if r.status_code != 200:
        print(f"❌ Failed to download {fasta_url}")
        return None

    with open(out_file, "wb") as f:
        for chunk in r.iter_content(chunk_size=8192):
            f.write(chunk)

    print(f"✅ Downloaded: {out_file}")
    return out_file


for sp in species_list:
    info = get_assembly_info(sp)
    if info is None:
        print(f"❌ No assembly found for {sp}")
        continue
    download_genome(info)
')
}

