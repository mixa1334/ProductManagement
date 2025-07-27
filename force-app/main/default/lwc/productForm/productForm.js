import { LightningElement, track, api } from 'lwc';
import createProduct from '@salesforce/apex/ProductTableController.createProduct';

export default class ProductForm extends LightningElement {
    @track formData = {};
    @track errorMsg = null;

    handleInput(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    cancel() {
        this._clearFormAndError();
        this.dispatchEvent(new CustomEvent('close'));
    }

    save() {
        const name = this.formData.Name;
        const price = parseFloat(this.formData.UnitPrice__c);

        if (!name || isNaN(price) || price <= 0) {
            this.errorMsg = 'Please fill in the required fields and enter a price greater than 0.';
            return;
        }

        createProduct({ newProduct: this.formData })
            .then(() => {
                this._clearFormAndError();
                this.dispatchEvent(new CustomEvent('save'));
            })
            .catch(error => console.log('Error: ', JSON.stringify(error)));
    }

    _clearFormAndError() {
        this.formData = {};
        this.errorMsg = null;
    }
}