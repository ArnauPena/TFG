classdef MatrixTester < handle
    
    properties (Access = private)
        testedData
        testerData
        matrixname
    end
    
    
    methods (Access = public)
        
        function obj = MatrixTester(s)
            obj.init(s)           
        end
        
        function compute(obj)
            if obj.computeError()
                cprintf('comment',obj.matrixname);
                cprintf('comment',' matrix is correct!\n');
            else
                cprintf('err',obj.matrixname);
                cprintf('err',' matrix is wrong!\n');
            end
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.testedData  = s.tested;
            obj.testerData  = s.tester;
            obj.matrixname  = s.matrixname;
        end
        
        function passed = computeError(obj)
            maxdiff = obj.checkMaxDifference();
            tolerance = 1e-5;
            if maxdiff > tolerance
                passed = 0;
            else
                passed = 1;
            end
        end
        
        function maxdiff = checkMaxDifference(obj)
            diff    = abs(obj.testedData - obj.testerData);
            maxdiff = max(max(diff));
        end
    end
    
end