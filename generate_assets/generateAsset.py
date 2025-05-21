from PIL import Image, ImageDraw, ImageFont
import os

WIDTH, HEIGHT = 512, 512
OUTPUT_DIR = "layers"

# Define your layers and traits with colors & simple shapes
layers = {
    "Background": [
        ("bg_blue", (10, 20, 100)),      # dark neon blue
        ("bg_purple", (120, 30, 180)),   # synthwave purple
        ("bg_grid", (20, 20, 20)),       # dark background for grid
    ],
    "Body": [
        ("body_white", (245, 245, 245)), # white cat
        ("body_black", (20, 20, 20)),    # black cat
        ("body_gold", (212, 175, 55)),   # gold cat
    ],
    "Eyes": [
        ("eyes_normal", (0, 255, 255)),  # cyan eyes
        ("eyes_laser", (255, 0, 0)),     # red laser eyes
        ("eyes_glitch", (255, 255, 0)),  # yellow glitch eyes
    ],
    "Headgear": [
        ("headgear_none", None),          # transparent (no headgear)
        ("headgear_vr", (0, 200, 200)),  # teal VR headset
        ("headgear_cap", (255, 105, 180))# pink synth cap
    ],
    "Mouth": [
        ("mouth_smile", (255, 100, 100)),  # soft red smile
        ("mouth_straight", (255, 255, 255)),# white neutral
        ("mouth_o", (255, 165, 0)),         # orange surprised O
    ],
}

os.makedirs(OUTPUT_DIR, exist_ok=True)

def draw_background(draw, color_name, color):
    if color_name == "bg_grid":
        # black bg with neon grid lines
        draw.rectangle([0,0,WIDTH,HEIGHT], fill=(10,10,10))
        spacing = 32
        for x in range(0, WIDTH, spacing):
            draw.line([(x, 0), (x, HEIGHT)], fill=(0, 255, 255, 50), width=1)
        for y in range(0, HEIGHT, spacing):
            draw.line([(0, y), (WIDTH, y)], fill=(0, 255, 255, 50), width=1)
    else:
        draw.rectangle([0,0,WIDTH,HEIGHT], fill=color)

def draw_body(draw, color):
    # simple cat body: ellipse in center
    draw.ellipse([(WIDTH*0.2, HEIGHT*0.3), (WIDTH*0.8, HEIGHT*0.9)], fill=color)

def draw_eyes(draw, color):
    # two circles in top middle area
    eye_radius = 30
    left_eye = (WIDTH*0.35, HEIGHT*0.45)
    right_eye = (WIDTH*0.65, HEIGHT*0.45)
    draw.ellipse([ (left_eye[0]-eye_radius, left_eye[1]-eye_radius), (left_eye[0]+eye_radius, left_eye[1]+eye_radius)], fill=color)
    draw.ellipse([ (right_eye[0]-eye_radius, right_eye[1]-eye_radius), (right_eye[0]+eye_radius, right_eye[1]+eye_radius)], fill=color)

def draw_headgear(draw, color_name, color):
    if color_name == "headgear_none":
        return
    if color_name == "headgear_vr":
        # rectangle visor
        visor_rect = [WIDTH*0.25, HEIGHT*0.2, WIDTH*0.75, HEIGHT*0.35]
        draw.rectangle(visor_rect, fill=color)
    if color_name == "headgear_cap":
        # triangle cap
        points = [(WIDTH*0.5, HEIGHT*0.15), (WIDTH*0.75, HEIGHT*0.3), (WIDTH*0.25, HEIGHT*0.3)]
        draw.polygon(points, fill=color)

def draw_mouth(draw, color_name, color):
    if color_name == "mouth_smile":
        # arc smile
        box = [WIDTH*0.4, HEIGHT*0.7, WIDTH*0.6, HEIGHT*0.75]
        draw.arc(box, start=20, end=160, fill=color, width=6)
    elif color_name == "mouth_straight":
        # straight line mouth
        draw.line([WIDTH*0.4, HEIGHT*0.725, WIDTH*0.6, HEIGHT*0.725], fill=color, width=6)
    elif color_name == "mouth_o":
        # circle O mouth
        center = (WIDTH*0.5, HEIGHT*0.72)
        radius = 15
        draw.ellipse([center[0]-radius, center[1]-radius, center[0]+radius, center[1]+radius], outline=color, width=6)

for layer_name, traits in layers.items():
    folder_path = os.path.join(OUTPUT_DIR, layer_name)
    os.makedirs(folder_path, exist_ok=True)
    
    for trait_name, color in traits:
        img = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)

        if layer_name == "Background":
            draw_background(draw, trait_name, color)
        elif layer_name == "Body":
            draw_body(draw, color)
        elif layer_name == "Eyes":
            draw_eyes(draw, color)
        elif layer_name == "Headgear":
            draw_headgear(draw, trait_name, color)
        elif layer_name == "Mouth":
            draw_mouth(draw, trait_name, color)

        # Save file
        filename = f"{trait_name}.png"
        img.save(os.path.join(folder_path, filename))

print(f"Layers generated in folder: {OUTPUT_DIR}")
