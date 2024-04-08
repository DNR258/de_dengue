from mage_ai.data_cleaner.transformer_actions.base import BaseAction
from mage_ai.data_cleaner.transformer_actions.constants import ActionType, Axis
from mage_ai.data_cleaner.transformer_actions.utils import build_transformer_action
from pandas import DataFrame

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test



@transformer
def execute_transformer_action(df: DataFrame, *args, **kwargs) -> DataFrame:
    """
    Execute Transformer Action: ActionType.CLEAN_COLUMN_NAME

    Docs: https://docs.mage.ai/guides/transformer-blocks#clean-column-names

    """
    df['ID_PROV_INDEC_RESIDENCIA']=df['ID_PROV_INDEC_RESIDENCIA'].fillna(0).astype('int')
    df['PROVINCIA_RESIDENCIA']=df['PROVINCIA_RESIDENCIA'].str.normalize('NFKD').str.encode('ascii',errors='ignore').str.decode('utf-8').str.upper()

    action = build_transformer_action(
        df,
        action_type=ActionType.CLEAN_COLUMN_NAME,
        arguments=df.columns,
        axis=Axis.COLUMN,
    )



    return BaseAction(action).execute(df)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
