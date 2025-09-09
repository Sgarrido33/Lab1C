from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return "Servidor del backend corriendo"

@app.route("/api/products")
def get_products():
    products = [
        {"id": 1, "name": "Laptop", "price": 1200},
        {"id": 2, "name": "Mouse", "price": 25},
        {"id": 3, "name": "Teclado", "price": 75}
    ]
    return jsonify(products)

if __name__ == "__main__":
    app.run(debug=True)