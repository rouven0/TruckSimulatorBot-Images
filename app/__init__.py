from flask import Flask, send_file, abort
from PIL import Image
from io import BytesIO
from os import listdir
from random import randint
import pathlib


app = Flask(__name__)

base_path = str(pathlib.Path(__file__).parent.resolve())
available_places = [place[: place.find(".")] for place in listdir(f"{base_path}/images/places")]


def serve_pil_image(pil_img):
    img_io = BytesIO()
    pil_img.save(img_io, "PNG")
    img_io.seek(0)
    return send_file(img_io, mimetype="image/png")


@app.route("/<base_id>/<place_id>/<truck_id>")
def place_image(base_id: str, place_id: str, truck_id: str):
    base = Image.open(f"{base_path}/images/bases/{base_id}.png")

    if place_id in available_places:
        place = Image.open(f"{base_path}/images/places/{place_id}.png")
        scaled_place = place.resize((596, 264))
        base.paste(scaled_place, (0, 0), scaled_place.convert("RGBA"))
    else:
        decoration = Image.open(f"{base_path}/images/decorations/{base_id}.png")
        for i in range(randint(3, 8)):
            base.paste(decoration, (randint(-10, 540), randint(-10, 189)), decoration.convert("RGBA"))
    truck = Image.open(f"{base_path}/images/trucks/{truck_id}.png")
    scaled_truck = truck.resize((340, 180))
    base.paste(scaled_truck, (200, 230), scaled_truck.convert("RGBA"))

    return serve_pil_image(base)


@app.route("/trucks/<truck_id>")
def get_truck(truck_id: str):
    try:
        return send_file(f"{base_path}/images/trucks/{truck_id}.png", mimetype="image/png")
    except FileNotFoundError:
        abort(404)


@app.route("/places/<place_id>")
def get_place(place_id: str):
    try:
        return send_file(f"{base_path}/images/places/{place_id}.png", mimetype="image/png")
    except FileNotFoundError:
        abort(404)


@app.route("/bases/<base_id>")
def get_base(base_id: str):
    try:
        return send_file(f"{base_path}/images/bases/{base_id}.png", mimetype="image/png")
    except FileNotFoundError:
        abort(404)


@app.route("/guide/<topic>")
def get_guide(topic: str):
    try:
        return send_file(f"{base_path}/images/guide/{topic}.png", mimetype="image/png")
    except FileNotFoundError:
        abort(404)


@app.route("/transparent")
def get_transparent():
    return send_file(f"{base_path}/images/transparent.png")


@app.route("/logo")
@app.route("/favicon.ico")
def get_logo():
    return send_file(f"{base_path}/images/logo.png")


@app.route("/robots.txt")
def get_robots():
    return send_file(f"{base_path}/robots.txt")


if __name__ == "__main__":
    app.run(port=9002, debug=True)
