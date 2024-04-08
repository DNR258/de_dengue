import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    data['provincia_residencia']=data['provincia_residencia'].str.upper()
    data['provincia_residencia'].replace('CABA', 'BUENOS AIRES', inplace=True)
    data['provincia_residencia'].fillna('UNSPECIFIED', inplace=True)
    
    data=data.groupby(['anio_min', 'sepi_min', 'provincia_residencia'], as_index=False)['total'].sum()

    data=data[['provincia_residencia', 'anio_min', 'sepi_min', 'total']]

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
