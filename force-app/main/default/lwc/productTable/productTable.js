import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductTableController.getProducts';

export default class ProductTable extends LightningElement {
    @track products = [];
    @track isFormVisible = false;

    connectedCallback() {
        this.reloadProducts();
    }

    openForm() {
        this.isFormVisible = true;
    }

    saveForm(){
        this.closeForm();
        this.reloadProducts();
    }

    closeForm() {
        this.isFormVisible = false;
    }

    reloadProducts() {
        getProducts()
            .then(products => this.products = products)
            .catch(error => console.log('Error: ', JSON.stringify(error)));
    }
}