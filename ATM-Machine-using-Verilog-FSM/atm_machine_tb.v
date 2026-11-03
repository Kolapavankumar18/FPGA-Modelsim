
module atm_tb;

    reg clk;
    reg reset;
    reg start;

    reg [15:0] pin;
    reg [1:0] txn_type;
    reg [15:0] amount;

    wire [15:0] balance;
    wire txn_done;
    wire pin_error;
    wire insufficient_funds;
    wire invalid_txn;

    // DUT
    atm_fsm dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .pin(pin),
        .txn_type(txn_type),
        .amount(amount),
        .balance(balance),
        .txn_done(txn_done),
        .pin_error(pin_error),
        .insufficient_funds(insufficient_funds),
        .invalid_txn(invalid_txn)
    );

    // Clock generation
    always #5 clk = ~clk;

    // ATM transaction task
    task atm_operation;
        input [15:0] entered_pin;
        input [1:0] operation;
        input [15:0] value;

        begin

            @(negedge clk);

            pin = entered_pin;
            txn_type = operation;
            amount = value;
            start = 1;

            @(negedge clk);
            start = 0;

            wait(txn_done == 1);

            #1;

            $display("--------------------------------");
            $display("PIN        = %h", pin);
            $display("Operation  = %b", txn_type);
            $display("Amount     = %0d", amount);
            $display("Balance    = %0d", balance);
            $display("PIN Error  = %b", pin_error);
            $display("Low Balance= %b", insufficient_funds);
            $display("Invalid TXN= %b", invalid_txn);
            $display("Transaction completed");
            $display("--------------------------------");

            @(negedge clk);

        end
    endtask

    initial
    begin

        clk = 0;
        reset = 1;
        start = 0;

        pin = 0;
        txn_type = 0;
        amount = 0;

        #12;
        reset = 0;

        $display("INITIAL BALANCE = %0d", balance);

        // 1. Balance enquiry
        atm_operation(16'h1234, 2'b00, 16'd0);

        // 2. Withdraw 2000
        atm_operation(16'h1234, 2'b01, 16'd2000);

        // 3. Deposit 5000
        atm_operation(16'h1234, 2'b10, 16'd5000);

        // 4. Insufficient balance
        atm_operation(16'h1234, 2'b01, 16'd20000);

        // 5. Wrong PIN
        atm_operation(16'h5678, 2'b00, 16'd0);

        // 6. Invalid transaction
        atm_operation(16'h1234, 2'b11, 16'd100);

        $display("FINAL BALANCE = %0d", balance);

        #20;
        $finish;

    end

endmodule
