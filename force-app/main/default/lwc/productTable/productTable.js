import { LightningElement } from 'lwc';
import getProducts from '@salesforce/apex/ProductTableController.getProducts';

export default class ProductTable extends LightningElement {
    products = [];

    connectedCallback() {
        getProducts()
            .then(products => {
                this.products = products;
            })
            .catch(error => {
                console.log(error);
            });
    }
}