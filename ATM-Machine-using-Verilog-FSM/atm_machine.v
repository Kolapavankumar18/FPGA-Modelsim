
module atm_fsm (
    input clk,
    input reset,
    input start,

    input [15:0] pin,
    input [1:0] txn_type,
    input [15:0] amount,

    output reg [15:0] balance,
    output reg txn_done,
    output reg pin_error,
    output reg insufficient_funds,
    output reg invalid_txn
);

    // FSM states
    parameter IDLE      = 3'b000;
    parameter PIN_CHECK = 3'b001;
    parameter MENU      = 3'b010;
    parameter EXECUTE   = 3'b011;
    parameter SUCCESS   = 3'b100;
    parameter ERROR     = 3'b101;

    // Transaction types
    parameter CHECK_BALANCE = 2'b00;
    parameter WITHDRAW      = 2'b01;
    parameter DEPOSIT       = 2'b10;

    // Correct PIN
    parameter [15:0] CORRECT_PIN = 16'h1234;

    reg [2:0] state;

    // Error codes
    reg [1:0] error_code;

    // Sequential FSM
    always @(posedge clk or posedge reset)
    begin

        if (reset)
        begin
            state <= IDLE;
            balance <= 16'd10000;

            txn_done <= 0;
            pin_error <= 0;
            insufficient_funds <= 0;
            invalid_txn <= 0;

            error_code <= 0;
        end

        else
        begin

            // Default pulse outputs
            txn_done <= 0;
            pin_error <= 0;
            insufficient_funds <= 0;
            invalid_txn <= 0;

            case(state)

                IDLE:
                begin
                    if(start)
                        state <= PIN_CHECK;
                end

                PIN_CHECK:
                begin
                    if(pin == CORRECT_PIN)
                        state <= MENU;
                    else
                    begin
                        error_code <= 2'd1;
                        state <= ERROR;
                    end
                end

                MENU:
                begin
                    state <= EXECUTE;
                end

                EXECUTE:
                begin

                    case(txn_type)

                        CHECK_BALANCE:
                        begin
                            state <= SUCCESS;
                        end

                        WITHDRAW:
                        begin
                            if(amount <= balance)
                            begin
                                balance <= balance - amount;
                                state <= SUCCESS;
                            end
                            else
                            begin
                                error_code <= 2'd2;
                                state <= ERROR;
                            end
                        end

                        DEPOSIT:
                        begin
                            balance <= balance + amount;
                            state <= SUCCESS;
                        end

                        default:
                        begin
                            error_code <= 2'd3;
                            state <= ERROR;
                        end

                    endcase

                end

                SUCCESS:
                begin
                    txn_done <= 1;
                    state <= IDLE;
                end

                ERROR:
                begin
                    txn_done <= 1;

                    case(error_code)

                        2'd1: pin_error <= 1;
                        2'd2: insufficient_funds <= 1;
                        2'd3: invalid_txn <= 1;

                    endcase

                    state <= IDLE;
                end

                default:
                    state <= IDLE;

            endcase

        end

    end

endmodule
