运行方法
===========
1.启动webase客户端，部署contract下合约。
2.进入blockchain目录下
  npm install
  npm start
3.使用浏览器访问localhost：3000


*加分项*

友好的用户界面：
使用边栏的形式方便用户随时切换功能。
简洁大方的美术风格。

关于供应链金融的设计：
  ```sol
  struct receipt {
		address from;//债主
		address to;
		uint amount;
		uint time;
		uint weight;//权重，to公司的信用越高，交易越可靠
		uint pid;//交易编号,通常为10的倍数，当完成一次债务转移生成的新债务pid加一，不再是10的倍数
	}
    ```
    独特的账单设计，账单权重与签发公司信用相关，拥有权重大的账单会使公司信用得到提高，更易得到贷款。体现区块链构建的信任机制。
    账单存在编号，可以显示账单的经手次数，当达到一定水平时，应限制账单的转让，以避免坏账。
    大作业专注于研究webase接口，对合约有所简化改动。
    


