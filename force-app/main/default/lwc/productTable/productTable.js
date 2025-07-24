import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductTableController.getProducts';
import createProduct from '@salesforce/apex/ProductTableController.createProduct';

export default class ProductTable extends LightningElement {
    @track products = [];
    @track isFormVisible = false;
    @track formData = {};
    @track errorMsg = null;

    connectedCallback() {
        getProducts()
            .then(products => {
                this.products = products;
            })
            .catch(error => this._handleError(error));
    }

    handleNew() {
        this._clearFormAndError(true);
    }

    handleCancel() {
        this._clearFormAndError();
    }

    handleInput(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    handleSave() {
        const name = this.formData.Name;
        const price = this.formData.UnitPrice__c = parseFloat(this.formData.UnitPrice__c);

        if (!name || isNaN(price) || price <= 0) {
            this.errorMsg = 'Please fill in the required fields and enter a price greater than 0.';
            return;
        }
        
        createProduct({ newProduct: this.formData })
            .then(updatedProducts => {
                this.products = updatedProducts;
                this._clearFormAndError();
            })
            .catch(error => this._handleError(error));
    }

    _clearFormAndError(formVisibility = false) {
        this.formData = {};
        this.errorMsg = null;
        this.isFormVisible = formVisibility;
    }

    _handleError(error) {
        console.log('Error:', JSON.stringify(error));
        this.errorMsg = error.body.message;
    }
}