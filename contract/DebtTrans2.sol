pragma solidity >=0.4.21 <0.6.0;
//pragma experimental ABIEncoderV2;

contract DebtTrans2{
    
    struct Receipt {
        uint id;            
    	address from;           //borrower
    	address to;             //receiver
    	uint value;             
    	uint startDate;        
    	uint endDate;          
    	bool isPay;          
    	bool isLoan;       
    }
    
    uint public receiptNum;                          
    address public automobileCompany;                 
    address private bankingHouse;                
    mapping(address => string)public compNames;    
    mapping(address => uint)public balances;    
    mapping(address => int32)public credit;     
    Receipt[] public receipts;          
    
    
    constructor() public {
        automobileCompany = msg.sender;
        bankingHouse = 0x6e37DBa5969f77E671b111b3c5cBF549981D3512;
        balances[bankingHouse] = 1996051600;
        balances[automobileCompany] = 1992031200;
        compNames[automobileCompany] = "automobilecompany";
        compNames[bankingHouse] = "bank";
        receiptNum = 0;
    }
    
    //time calculate in days
    function SignReceipt(address receiver, uint amount, uint timeLeft)public {

        if(msg.sender == automobileCompany){ 

            uint timeTemp = now + timeLeft * 1 days;
            
            receipts.push(Receipt({
                id: receiptNum,
                from: msg.sender,
                to: receiver,
                value: amount,
                startDate: now,
                endDate: timeTemp,
                isPay:false,
                isLoan:false
            }));
            
            receiptNum ++;
            credit[msg.sender] -= int32(amount);
            credit[receiver] += int32(amount);
        }
    }
    
    //split the receipt to other companies, amount must lower than the value you have
    function TransferDebtReceipt(address receiver, uint amount)public{

        uint tempreceiptNum = 0;
        for(uint i = 0; i < receipts.length; i ++){
            if(receipts[i].to == msg.sender && receipts[i].value >= amount && receipts[i].isPay == false && receipts[i].isLoan == false){
                tempreceiptNum = i;
                receipts[i].value -= amount;
                credit[msg.sender] -= int32(amount);
 
                receipts.push(Receipt({
                    id: receiptNum,
                    from: receipts[i].from,
                    to: receiver,
                    value: amount,
                    startDate: now,
                    endDate: receipts[i].endDate,
                    isPay:false,
                    isLoan:false
                }));
                receiptNum ++;
                credit[receiver] += int32(amount);
            }
        }
    }
    

    
   
    function Loan(address from, address to)public{
  
        if(msg.sender != bankingHouse){
            revert("no have the right to Loan");
        }
        else{
            for(uint i = 0; i < receipts.length; i ++){
                if(receipts[i].from == from && receipts[i].to == to && receipts[i].isPay == false && receipts[i].isLoan == false){
                    receipts[i].to = bankingHouse;
                    receipts[i].isLoan == true;
                    credit[to] -= int32(receipts[i].value);
                    credit[bankingHouse] += int32(receipts[i].value);
                    balances[to] += receipts[i].value;
                    balances[bankingHouse] -= receipts[i].value;
                }
            }
        }
    }
    

    function PayDebt()public{
        if(msg.sender == automobileCompany){
            for(uint i = 0; i < receipts.length; i ++){
                if(now >= receipts[i].endDate){
                    if(receipts[i].isPay == false){
                        balances[receipts[i].to] += receipts[i].value;
                        credit[receipts[i].to] -= int32(receipts[i].value);
                        balances[receipts[i].from] -= receipts[i].value;
                        credit[receipts[i].from] += int32(receipts[i].value);
                        receipts[i].isPay = true;
 
                    }
                }
            }
        }
        else{
            revert("no have the right to pay debt");
        }
    }

    function getCredit(address addr) public view returns(int) {
        return credit[addr];
    }

    function getBalance() public view returns(uint) {
        return balances[msg.sender];
    }

    function setName(string memory name2) public{
        if(msg.sender == bankingHouse){
            revert("Sorry! The bank can't change name!");
        }
        compNames[msg.sender] = name2;
    }

    function getName(address addr) public view returns(string memory) {
        return compNames[addr];
    }

}