classdef Tester < handle
    
    properties (Access = private)
        u  
    end
    properties (Access = public)
        displacements
    end
    
    methods (Access = public)
        function obj = Tester(s)
            obj.computeTest(s);
        end
    end
    methods (Access = private)
        function obj = computeTest(obj,s)
            obj.testFEM(s);
        end
    
        function checkDisplacements(obj)
            dif = abs(obj.u-obj.displacements)/obj.displacements;
            if dif < 1e-10
                cprintf('comment','Code is correct!');
            else
                cprintf('err','Something is wrong!');
            end
        end
        
        function obj = testFEM(obj,s)
            Femtest = FEMcomputer(s);
            Femtest.solve();
            obj.displacements = Femtest.displacement;
            obj.u             = Femtest.u;
            obj.checkDisplacements();
        end
    end
end

