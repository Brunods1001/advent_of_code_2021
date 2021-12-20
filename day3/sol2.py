import pandas as pd

def read_ser() -> pd.Series:
    ser = pd.read_table("./data.txt", header=None).squeeze()
    ser = ser.apply(str)
    return ser


def read_df() -> pd.DataFrame:
    ser = read_ser()
    df = ser.str.split('', expand=True).loc[:, 1:]
    return df

def calc_O2(vec: list[str]) -> float:
    ...

def calc_CO2(vec: list[str]) -> float:
    ...

def calc_life_support(O2: float, CO2: float) -> float:
    return O2 * CO2

def filter_bits(ser: pd.Series, index: int) -> pd.Series:
    ser_most_common = ser.str[index].mode()
    if ser_most_common.size:
        most_common = ser_most_common[0]
        return ser.loc[ser.str[index] == most_common]
    else:
        return pd.Series([])

def clean_data(ser: pd.Series) -> pd.Series:
    i = 0
    while True:
        mode = filter_bits(ser, i)
        i ++

def main():
    ser = read_series()
    bits_O2 = filter_bits(ser, index=0)
    bits_CO2 = filter_bits(ser, index=1)
    calc_life_support(O2, CO2)
    print(df)


if __name__ == "__main__":
    main()
