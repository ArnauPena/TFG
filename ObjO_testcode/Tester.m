classdef Tester < handle
    
    properties (Access = private)
        u  
    end
    properties (Access = public)
        displacements
    end
    
    methods (Access = public)
        function obj = Tester(staticfiledata,solver_type)
            Test = FEMcomputer(staticfiledata,solver_type);
            Test.solve();
            obj.displacements = Test.displacement;
            obj.u = Test.u;
            obj.computeTest();
        end
    end
    methods (Access = private)
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

