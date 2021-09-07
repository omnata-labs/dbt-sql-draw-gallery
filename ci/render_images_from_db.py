import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
import psycopg2
import os
import math
import re
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
        cur.execute(f"select string_agg ( coalesce(colour,'#ffffff'), '|' order by x ) from {table_name} where y is not null group by y order by y;")
        result_set = cur.fetchall()
        numpy_array = np.array(result_set) #, dtype = [("x", float), ("y", float), ("colour", str)])
        generate_image_file(numpy_array,file_name,draw_grid)

def string_to_rgb(colour_string_list):
    rgb_triple_array = []
    four_char_hex = re.compile('([A-F|a-f|0-9]){4}')
    six_char_hex = re.compile('([A-F|a-f|0-9]){4}')
    for colour_string in colour_string_list:
        # basic check
        if len(colour_string) < 3:
            raise ValueError(f"Invalid colour (too short): {colour_string}")

        # make hash character optional
        if len(colour_string) == 3 and four_char_hex.match(colour_string) is not None:
            colour_string = f'#{colour_string}'
        if len(colour_string) == 6 and six_char_hex.match(colour_string) is not None:
            colour_string = f'#{colour_string}'

        if colour_string[0:3]=='rgb':
            # rgb string, e.g. rgb(0,0,255) or rgb(0.5,0.5,0.7)
            try:
                component_string_list = colour_string.replace("rgb(", "").replace(")", "").split(',')
                rgb_array=[]
                for component_string in component_string_list:
                    float_val = float(component_string)
                    if float_val > 0 and float_val < 1:
                        rgb_array.append(round(255*float_val))
                    else:
                        rgb_array.append(int(float_val))
                rgb_triple_array.append(rgb_array)
            except:
                raise ValueError(f"Could not parse rgb colour: {colour_string}")
        elif colour_string[0]=='#':
            # 6 character hex, e.g. #FF0000
            if len(colour_string)==7:
                try:
                    rgb_triple_array.append([int(colour_string[1:3],16),int(colour_string[3:5],16),int(colour_string[5:7],16)])
                except:
                    raise ValueError(f"Could not parse 6 character hex colour: {colour_string}")
            # 3 character hex, e.g. #6A7
            elif len(colour_string)==4:
                try:
                    rgb_triple_array.append([int(colour_string[1:2],16),int(colour_string[2:3],16),int(colour_string[3:4],16)])
                except:
                    raise ValueError(f"Could not parse 3 character hex colour: {colour_string}")
            else:
                raise ValueError(f"Hex colours must be 3 or 6 characters in length: {colour_string}")
        else:
            raise ValueError(f"Unknown colour format: {colour_string}")
    return rgb_triple_array

def generate_image_file(numpy_array,file_path,show_grid):
    fig, ax = plt.subplots()
    # Array comes in as a comma separated list of hex colours, one for each row of the image.
    # We split them into a 2d array, then convert each hex code into a [r,g,b] array of ints.
    # The end result is a 3d array of x,y,(colour components)
    split_colours = np.char.split(numpy_array, sep ='|')
    colours_rgb = np.array([string_to_rgb(xi) for xi in split_colours[:,0].tolist()])
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