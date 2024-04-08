import pyarrow as pa
import pyarrow.parquet as pq
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENTIALS']='/home/src/my-creds.json'

bucket_name='elaborate-tube-412620-denge-bucket'
project_id='elaborate-tube-412620'

table_name='y2023-dengue-data'

root_path= f'{bucket_name}/{table_name}'


@data_exporter
def export_data(data, *args, **kwargs):

    table=pa.Table.from_pandas(data)
    gcs=pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path,
        filesystem=gcs
    )


