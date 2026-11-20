from pathlib import Path
import duckdb

BASE = Path(__file__).resolve().parent
SQL_DIR = BASE / "consultas"


def leer_sql(nombre_archivo: str):
    return (SQL_DIR / nombre_archivo).read_text(encoding="utf-8")


def ejecutar_pipeline():
    con = duckdb.connect("pipeline.duckdb")

    con.execute(leer_sql("extract.sql"))
    con.execute(leer_sql("validar.sql"))
    validos_cnt = con.execute("SELECT COUNT(*) FROM datos_validos;").fetchone()[0]
    rechazados_cnt = con.execute("SELECT COUNT(*) FROM rechazados;").fetchone()[0]
    print(f"datos validos {validos_cnt}")
    print(f"datos rechazados {rechazados_cnt}")

    con.execute(leer_sql("limpiar.sql"))
    con.execute(leer_sql("unir.sql"))
    total_final = con.execute("SELECT COUNT(*) FROM tabla_final").fetchone()[0]
    print(f"total final:{total_final}")

    con.close()
    print("pipeline ejecutado exitosamente")


if __name__ == "__main__":
    ejecutar_pipeline()
