pragma solidity >=0.4.22 <0.6.0;
contract DebtTrans {
	address public bank;
	
	struct receipt {
		address from;//债主
		address to;
		uint amount;
		uint time;
		uint weight;//权重，to公司的信用越高，交易越可靠
		uint pid;//交易编号,通常为10的倍数，当完成一次债务转移生成的新债务pid加一，不再是10的倍数
	}

	mapping(address => uint) public credit;//公司在银行处的信用,数值越低信用越高
	
	mapping(address => uint) public balance;//公司钱
	mapping(address => receipt[]) public r_owe;//receipt中为to的一方
	mapping(address => receipt[]) public r_receive;//receipt中为from的一方

	constructor() public {
        bank = msg.sender;
    }

    function set_credit(address company, uint amount) public{
    	if(msg.sender != bank)
    		return;
    	credit[company] = amount; 
    }
    function set_balance(address company, uint amount) public{
    	if(msg.sender != bank)
    		return;
    	balance[company] = amount; 
    }
    function loan(uint amount) public{ //银行根据信用借钱给公司
    	//完善增加根据持有较大权重的白条也可借款
    	if(credit[msg.sender] > 5){
    		for(uint i=0; i < r_receive[msg.sender].length; i++)
    			if(credit[r_receive[msg.sender][i].to] < 5)
    				balance[msg.sender] += amount;
    	}
    	else
    		balance[msg.sender] += amount;
    }

    function issue_iou(address oweto, uint amount, uint time, uint weight,uint pid) public{ // 打白条
    	//完善根据白条to方信用确定权重
    	r_owe[msg.sender].push(receipt(oweto,msg.sender,amount,time,weight,pid));
    	r_receive[oweto].push(receipt(oweto,msg.sender,amount,time,weight,pid));
    }
    // function delete_receipt_i(receipt[] r, uint index) public {
    // 	for(uint i=index; i < r.length-1; i ++)
    // 		r[i] = r[i + 1];
    // 	delete r[r.length - 1];
    // 	r.length -= 1;
    // }

    function pay_to(uint time) public { //到期交钱
    	for(uint i = 0; i < r_owe[msg.sender].length; i ++) {
    		if(r_owe[msg.sender][i].time == time) {
    			address ower = r_owe[msg.sender][i].from;//债主
    			for(uint j = 0; j < r_receive[ower].length; j ++){
    				if(r_receive[ower][j].pid == r_owe[msg.sender][i].pid) {
    					balance[ower] += r_owe[msg.sender][i].amount;
    					uint k;
    					for(k=j; k < r_receive[ower].length-1; k ++)
                            r_receive[ower][k] = r_receive[ower][k + 1];
                        delete r_receive[ower][r_receive[ower].length - 1];
                        r_receive[ower].length -= 1;
                        break;
    				}
    			}
    			balance[msg.sender] -= r_owe[msg.sender][i].amount;
    			//delete_receipt_i(r_owe[msg.sender], i);
    			for(k=i; k < r_owe[msg.sender].length-1; k ++)
                    r_owe[msg.sender][k] = r_owe[msg.sender][k + 1];
                delete r_owe[msg.sender][r_owe[msg.sender].length - 1];
                r_owe[msg.sender].length -= 1;
    			i --;
    		}
    	}
    }
    function receive_from(uint time) public { //到期收钱
    	for(uint i = 0; i < r_receive[msg.sender].length; i ++) {
    		if(r_receive[msg.sender][i].time == time) {
    			address borrower = r_receive[msg.sender][i].to;
    			for(uint j = 0; j < r_owe[borrower].length; j ++){
    				if(r_owe[borrower][j].pid == r_receive[msg.sender][i].pid) {
    					balance[borrower] -= r_receive[msg.sender][i].amount;
    					//delete_receipt_i(r_owe[borrower], j);
    					uint k;
    					for(k=j; k < r_owe[borrower].length-1; k ++)
                            r_owe[borrower][k] = r_owe[borrower][k + 1];
                        delete r_owe[borrower][r_owe[borrower].length - 1];
                        r_owe[borrower].length -= 1;
    				}
    			}
    			balance[msg.sender] += r_receive[msg.sender][i].amount;
    			//delete_receipt_i(r_receive[msg.sender], i);
    			for(k=i; k < r_receive[msg.sender].length -1; k ++)
                    r_receive[msg.sender][k] = r_receive[msg.sender][k + 1];
                delete r_receive[msg.sender][r_receive[msg.sender].length - 1];
                r_receive[msg.sender].length -= 1;
    			i --;
    		}
    	}
    }
    function receipt_trans(address giveto, uint amount) public { //债务转让
    	for(uint i=0; i < r_receive[msg.sender].length; i++) {
    		address temp = r_receive[msg.sender][i].to;

    		if(r_receive[msg.sender][i].amount > amount) {
    		    uint j;
    			for(j=0; j < r_owe[temp].length; j++) {
    				if(r_owe[temp][j].pid == r_receive[msg.sender][i].pid)
    					r_owe[temp][j].amount -= amount;
    					break;
    			} 
    			r_receive[msg.sender][i].amount -= amount;
    			r_receive[giveto].push(receipt(giveto,temp,amount,r_receive[msg.sender][i].time,r_receive[msg.sender][i].weight,r_receive[msg.sender][i].pid + 1));
    			r_owe[temp].push(receipt(giveto,temp,amount,r_receive[msg.sender][i].time,r_receive[msg.sender][i].weight,r_receive[msg.sender][i].pid + 1));
    			break;
    		}
    		else{
    			for(j=0; j < r_owe[temp].length; j++) {
    				if(r_owe[temp][j].pid == r_receive[msg.sender][i].pid){
    					delete r_owe[temp][j];
    					uint k;
    					for(k = j; k < r_owe[temp].length - 1; k++)
    						r_owe[temp][k] = r_owe[temp][k+1];
    					delete r_owe[temp][r_owe[temp].length - 1];
    					r_owe[temp].length -= 1;
    					break;
    				}
    			}

    			amount -= r_receive[msg.sender][i].amount;
    			

    			for(k = i; k < r_receive[msg.sender].length - 1; k++)
    				r_receive[msg.sender][k] = r_receive[msg.sender][k + 1];
    			delete r_receive[msg.sender][r_receive[msg.sender].length - 1];
    			r_receive[msg.sender].length -= 1;
    			i --;
    			r_owe[temp].push(receipt(giveto,temp,amount,r_receive[msg.sender][i].time,r_receive[msg.sender][i].weight,r_receive[msg.sender][i].pid + 1));
    			r_receive[giveto].push(receipt(giveto,temp,amount,r_receive[msg.sender][i].time,r_receive[msg.sender][i].weight,r_receive[msg.sender][i].pid + 1));
    		}

    	}
    }
}
