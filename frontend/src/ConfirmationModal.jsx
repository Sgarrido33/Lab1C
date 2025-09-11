import React from 'react';
import './Modal.css'; 

function ConfirmationModal({ message, onConfirm, onCancel, isOpen }) {
  if (!isOpen) {
    return null;
  }

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <p>{message}</p>
        <div className="modal-actions">
          <button onClick={onCancel} className="secondary">Cancelar</button>
          <button onClick={onConfirm}>Confirmar</button>
        </div>
      </div>
    </div>
  );
}

export default ConfirmationModal;