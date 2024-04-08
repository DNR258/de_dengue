import io
import pandas as pd
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    
    url = 'https://drive.google.com/file/d/1NDCbYraDM3hmfxsWozRMZJT7W5jnzujQ/view?usp=drive_link'

    file_id = url.split('/')[-2]
    dwn_url='https://drive.google.com/uc?export=download&id=' + file_id
        
    response = requests.get(dwn_url)

    hist_dtypes = {
    'adm_0_name':str, 
    'adm_1_name':str, 
    'adm_2_name':str, 
    'full_name':str, 
    'ISO_A0':str,
    'FAO_GAUL_code':int, 
    'RNE_iso_code':str, 
    'IBGE_code':str, 
    'Year':int, 
    'dengue_total':int,
    'case_definition_standardised':str, 
    'S_res':str, 
    'T_res':str, 
    'UUID':str
    }

    parse_dates = ['calendar_start_date', 'calendar_end_date']

    return pd.read_csv(io.StringIO(response.text), sep=',', dtype=hist_dtypes, parse_dates=parse_dates)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
