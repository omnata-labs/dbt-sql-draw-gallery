import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
import psycopg2
import os
import math
from matplotlib.path import Path
from matplotlib.patches import PathPatch, Rectangle
from matplotlib.collections import PatchCollection


def connect_and_export():
    # Connect to an existing database
    conn = psycopg2.connect(dbname=os.environ["POSTGRES_DB_NAME"],user=os.environ["POSTGRES_USERNAME"], password=os.environ["POSTGRES_PASSWORD"],host=os.environ["POSTGRES_HOSTNAME"], options=f"-c search_path={os.environ['POSTGRES_SCHEMA_NAME']}")

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this creates a new table
    cur.execute(f"select table_name from information_schema.tables where table_schema='{os.environ['POSTGRES_SCHEMA_NAME']}';")# and table_name='test_3_9';")
    draw_grid = True if "GRID" in os.environ else False
    for row in cur.fetchall():
        table_name=row[0]
        print(f"Generating image from {table_name}")
        file_name=f"target/images/{table_name}.png"
        cur.execute(f"select string_agg ( coalesce(colour,'#ffffff'), ',' order by x ) from {table_name} where y is not null group by y order by y;")
        result_set = cur.fetchall()
        numpy_array = np.array(result_set) #, dtype = [("x", float), ("y", float), ("colour", str)])
        generate_image_file(numpy_array,file_name,draw_grid)
    cur.execute(f"drop schema sql_draw cascade;")
    cur.execute(f"create schema sql_draw;")

def generate_image_file(numpy_array,file_path,show_grid):

    def hex_to_rgb(hex):
        return [[int(x[1:3],16),int(x[3:5],16),int(x[5:7],16)] for x in hex]

    fig, ax = plt.subplots()
    # Array comes in as a comma separated list of hex colours, one for each row of the image.
    # We split them into a 2d array, then convert each hex code into a [r,g,b] array of ints.
    # The end result is a 3d array of x,y,(colour components)
    split_colours = np.char.split(numpy_array, sep =',')
    colours_rgb = np.array([hex_to_rgb(xi) for xi in split_colours[:,0].tolist()])
    height=len(colours_rgb)
    width=len(colours_rgb[0])

    print(f"width: {width}, height: {height}")
    major_tick_interval = math.floor(max(width,height) / 10)
    minor_tick_interval = math.floor(max(width,height) / 20)
    if major_tick_interval < 1:
        major_tick_interval = 1
    if minor_tick_interval < 1:
        minor_tick_interval = 1
    print(f"major_tick_interval: {major_tick_interval}, minor_tick_interval: {minor_tick_interval}")

    ax.imshow(colours_rgb, interpolation='nearest', extent=[0.5,width+0.5,0.5,height+0.5],origin='lower', aspect='equal')

    ax.set_aspect(1)

    if show_grid:
        plt.xlabel("x")
        plt.ylabel("y   ", rotation=0)
        ax.set_ylim((0.5,height+1))
        ax.set_xlim((0.5,width+1))
        ax.set_xticks(np.arange(0, width+1, major_tick_interval))
        ax.set_xticks(np.arange(0, width+1, minor_tick_interval), minor=True)
        ax.set_yticks(np.arange(0, height+1, major_tick_interval))
        ax.set_yticks(np.arange(0, height+1, minor_tick_interval), minor=True)
        # And a corresponding grid
        ax.grid(which='minor', alpha=0.2)
        ax.grid(which='major', alpha=0.5)
    else:
        ax.set_ylim((0.5,height+0.5))
        ax.set_xlim((0.5,width+0.5))
        ax.grid(False)
        # Hide axes ticks
        ax.set_xticks([])
        ax.set_yticks([])
    fig.savefig(file_path, dpi=200,bbox_inches='tight')
    plt.close(fig)

connect_and_export()