/*hvl_top should have items that need to be in a module but are not synthesizable. 
This includes the import of the test package and call to run_test that starts the UVM phases. 
*/
//include files

import uvm_pkg::*;
`include "uvm_macros.svh"

import decode_in_pkg::*;
import decode_out_pkg::*;
import decode_test_pkg::*;


module hvl_top();
    initial begin
        run_test("test_top");
    end
endmodule:hvl_top