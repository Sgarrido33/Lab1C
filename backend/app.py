import os
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

basedir = os.path.abspath(os.path.dirname(__file__))

#Ruta de conexion para flask+sqlalchemy
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'pos.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# --- Modelo ---
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)

    def to_dict(self):
        return {"id": self.id, "name": self.name, "price": self.price}

# --- Api Endpoints ---
@app.route("/api/products", methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products])

@app.route("/api/products", methods=['POST'])
def add_product():
    data = request.get_json()
    if not data or not 'name' in data or not 'price' in data:
        return jsonify({'error': 'Missing data'}), 400

    new_product = Product(name=data['name'], price=data['price'])
    db.session.add(new_product)
    db.session.commit()
    return jsonify(new_product.to_dict()), 201

@app.route("/api/products/<int:id>", methods=['DELETE'])
def delete_product(id):
    product = Product.query.get(id)
    if product is None:
        return jsonify({'error': 'Product not found'}), 404

    db.session.delete(product)
    db.session.commit()
    return jsonify({'message': 'Product deleted'}), 200

with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)