import pandas as pd

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    url = 'http://datos.salud.gob.ar/dataset/ceaa8e87-297e-4348-84b8-5c643e172500/resource/19075374-b180-48a0-aaaf-e0e44cd6816f/download/informacion-publica-dengue-zika-nacional-se-1-a-52-de-2023.xlsx'
    
    yearly_dtype={
    'ID_DEPTO_INDEC_RESIDENCIA':int, 
    'DEPARTAMENTO_RESIDENCIA':str,
    'ID_PROV_INDEC_RESIDENCIA':str, 
    'PROVINCIA_RESIDENCIA':str, 
    'ANIO_MIN':int,
    'EVENTO':str, 
    'ID_GRUPO_ETARIO':int, 
    'GRUPO_ETARIO':str, 
    'SEPI_MIN':int, 
    'Total':int
    }

    na_values = {'ID_PROV_INDEC_RESIDENCIA': '(en blanco)'}

    return pd.read_excel(url, na_values=na_values, dtype=yearly_dtype)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
