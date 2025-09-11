import { useState, useEffect } from 'react';
import './App.css'; 

const API_URL = 'http://localhost:5000/api/products';

function App() {
  const [products, setProducts] = useState([]);
  const [cart, setCart] = useState([]);

  useEffect(() => {
    fetchProducts();
  }, []);

  async function fetchProducts() {
    const response = await fetch(API_URL);
    const data = await response.json();
    setProducts(data);
  }

  function addToCart(product) {
    setCart(currentCart => {
        const existingItem = currentCart.find(item => item.id === product.id);
        if (existingItem) {
            return currentCart.map(item =>
                item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
            );
        }
        return [...currentCart, { ...product, quantity: 1 }];
    });
  }

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

  return (
    <main className="container">
      <ProductsPanel products={products} onAddToCart={addToCart} />
      <CartPanel cart={cart} total={total} />
      <AddProductPanel onProductAdded={fetchProducts} />
    </main>
  );
}

// --- Componentes ---

function ProductsPanel({ products, onAddToCart }) {
  return (
    <article>
      <header><h2>Productos</h2></header>
      <ul>
        {products.map(product => (
          <li key={product.id}>
            <span>{product.name} - ${product.price.toFixed(2)}</span>
            <button onClick={() => onAddToCart(product)}>Agregar</button>
          </li>
        ))}
      </ul>
    </article>
  );
}

function CartPanel({ cart, total }) {
  return (
    <article>
      <header><h2>Carrito</h2></header>
      <ul>
        {cart.map(item => (
          <li key={item.id}>
            {item.name} (x{item.quantity}) - ${(item.price * item.quantity).toFixed(2)}
          </li>
        ))}
      </ul>
      <h3>Total: ${total.toFixed(2)}</h3>
    </article>
  );
}

function AddProductPanel({ onProductAdded }) {
  async function handleSubmit(event) {
    event.preventDefault();
    const form = event.target;
    const name = form.name.value;
    const price = parseFloat(form.price.value);

    const response = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, price })
    });

    if (response.ok) {
        onProductAdded(); 
        form.reset();
    } else {
        alert('Error al agregar el producto.');
    }
  }

  return (
    <article>
      <header><h2>Agregar Nuevo Producto</h2></header>
      <form onSubmit={handleSubmit}>
        <input type="text" name="name" placeholder="Nombre del producto" required />
        <input type="number" name="price" placeholder="Precio" step="0.01" required />
        <button type="submit">Agregar Producto</button>
      </form>
    </article>
  );
}

export default App;