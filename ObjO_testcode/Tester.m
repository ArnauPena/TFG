classdef Tester < handle
    
    properties (Access = public)
        u
        displacements  
    end
    
    methods (Access = public)
        function obj = Tester(staticfiledata)
            Test = FEMcomputer(staticfiledata);
            obj.displacements = Test.displacement;
            obj.u = Test.u;
            obj.computeTest();
        end
        function obj = computeTest(obj)
            obj.check();
        end
    
        function check(obj)
            dif = abs(obj.u-obj.displacements)/obj.displacements;
            if dif < 1e-10
                cprintf('comment','Code is correct!');
            else
                cprintf('err','Something is wrong!');
            end
        end
    end
end

