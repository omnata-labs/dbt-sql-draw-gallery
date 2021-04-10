import matplotlib.pyplot as plt
import numpy as np
import psycopg2
import os
import math

def connect_and_export():
    # Connect to an existing database
    conn = psycopg2.connect(dbname=os.environ["POSTGRES_DB_NAME"],user=os.environ["POSTGRES_USERNAME"], password=os.environ["POSTGRES_PASSWORD"],host=os.environ["POSTGRES_HOSTNAME"], options=f"-c search_path={os.environ['POSTGRES_SCHEMA_NAME']}")

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this creates a new table
    cur.execute(f"select table_name from information_schema.tables where table_schema='{os.environ['POSTGRES_SCHEMA_NAME']}';")
    for row in cur.fetchall():
        table_name=row[0]
        print(f"Generating image from {table_name}")
        file_name=f"target/images/{table_name}.png"
        cur.execute(f"SELECT x,y,colour FROM {table_name} order by x,y;")
        numpy_array = np.array(cur.fetchall())
        generate_image_file(numpy_array,file_name,True)


def generate_image_file(numpy_array,file_path,show_grid):
    x=numpy_array[:, 0]
    width=len(np.unique(x))
    y=numpy_array[:, 1]
    height=len(np.unique(y))
    print(f"width: {width}, height:{height}")
    c=numpy_array[:, 2]
    major_tick_interval = math.floor(max(width,height) / 10)
    minor_tick_interval = math.floor(max(width,height) / 20)
    if major_tick_interval < 1:
        major_tick_interval = 1
    if minor_tick_interval < 1:
        minor_tick_interval = 1
    
    size=math.ceil(10000 / (max(width,height) * 0.5))
    print(f"size: {size}")
    fig, ax = plt.subplots()
    ax.scatter(x, y, c=c, alpha=1,marker="s",s=size,linewidths=1,edgecolors='none')
    ax.set_ylim((0,height))
    ax.set_xlim((0,width))
    x0,x1 = ax.get_xlim()
    y0,y1 = ax.get_ylim()
    ax.set_aspect(1)

    if show_grid:
        ax.set_xticks(np.arange(0, width, major_tick_interval))
        ax.set_xticks(np.arange(0, width, minor_tick_interval), minor=True)
        ax.set_yticks(np.arange(0, height, major_tick_interval))
        ax.set_yticks(np.arange(0, height, minor_tick_interval), minor=True)
        # And a corresponding grid
        ax.grid(which='minor', alpha=0.2)
        ax.grid(which='major', alpha=0.5)
    else:
        ax.grid(False)
        # Hide axes ticks
        ax.set_xticks([])
        ax.set_yticks([])
    fig.savefig(file_path, dpi=200,bbox_inches='tight')
    plt.close(fig)

connect_and_export()