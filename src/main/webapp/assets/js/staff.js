const paymentMethod = document.querySelector('#counter-method');
const transactionReference = document.querySelector('#counter-transactionRef');
if (paymentMethod && transactionReference) {
    const updateRequirement = () => {
        transactionReference.required = paymentMethod.value === 'ONLINE';
    };
    paymentMethod.addEventListener('change', updateRequirement);
    updateRequirement();
}
