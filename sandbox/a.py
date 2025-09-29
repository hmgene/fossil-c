from dask.distributed import Client
import dask_cudf
import cudf

# Connect to the cluster
client = Client(scheduler_file='/mnt/vstor/SOM_GENE_BEG33/dask-workspace/scheduler.json')

print("Connected to Dask cluster")
print(client.dashboard_link)
print("Workers:", client.ncores())

# Test: Create small GPU DataFrame
df = cudf.DataFrame({
    'x': range(1000),
    'y': [i * 2 for i in range(1000)],
    'label': ['A', 'B'] * 500
})

ddf = dask_cudf.from_cudf(df, npartitions=2)
result = ddf.groupby('label').x.mean().compute()

print("GroupBy result:")
print(result)

client.close()   
