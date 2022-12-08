using System;

namespace DTO
{
    public class BillDetailDTO
    {
        //Fields
        private string billId;
        private string productId;
        private int quantity;

        //Properties
        public string BillId { get => billId; set => billId = value; }
        public string ProductId { get => productId; set => productId = value; }
        public int Quantity { get => quantity; set => quantity = value; }

        //Constructor
        public BillDetailDTO(string billId, string productId, int quantity)
        {
            BillId = billId;
            ProductId = productId;
            Quantity = quantity;
        }
    }
}
