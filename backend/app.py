import os
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)

# --- Configuración de la Base de Datos ---
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'pos.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# --- Modelos de la Base de Datos ---

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)

    def to_dict(self):
        return {"id": self.id, "name": self.name, "price": self.price}

class Sale(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    total = db.Column(db.Float, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    items = db.relationship('SaleItem', backref='sale', lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "total": self.total,
            "created_at": self.created_at.isoformat(),
            "items": [item.to_dict() for item in self.items]
        }

class SaleItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sale_id = db.Column(db.Integer, db.ForeignKey('sale.id'), nullable=False)
    product_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Float, nullable=False)

    def to_dict(self):
        return {
            "product_name": self.product_name,
            "quantity": self.quantity,
            "price": self.price
        }

# --- Endpoints de la API para Productos ---

@app.route("/api/products", methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products])

@app.route("/api/products", methods=['POST'])
def add_product():
    data = request.get_json()
    new_product = Product(name=data['name'], price=data['price'])
    db.session.add(new_product)
    db.session.commit()
    return jsonify(new_product.to_dict()), 201

@app.route("/api/products/<int:id>", methods=['DELETE'])
def delete_product(id):
    product = Product.query.get_or_404(id)
    db.session.delete(product)
    db.session.commit()
    return jsonify({'message': 'Product deleted'}), 200

# --- Endpoints de la API para Ventas ---

@app.route("/api/sales", methods=['POST'])
def create_sale():
    cart_items = request.get_json()
    if not cart_items:
        return jsonify({'error': 'Cart is empty'}), 400

    total = sum(item['price'] * item['quantity'] for item in cart_items)
    
    new_sale = Sale(total=total)
    db.session.add(new_sale)
    db.session.flush()  # Asigna un ID a new_sale antes del commit

    for item in cart_items:
        sale_item = SaleItem(
            sale_id=new_sale.id,
            product_name=item['name'],
            quantity=item['quantity'],
            price=item['price']
        )
        db.session.add(sale_item)
    
    db.session.commit()
    return jsonify(new_sale.to_dict()), 201

@app.route("/api/sales", methods=['GET'])
def get_sales():
    sales = Sale.query.order_by(Sale.created_at.desc()).all()
    return jsonify([sale.to_dict() for sale in sales])

# Crear la base de datos si no existe
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)