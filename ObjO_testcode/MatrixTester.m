classdef MatrixTester < handle
    
    properties (Access = private)
        testedData
        testerData
        matrixname
    end
    
    
    methods (Access = public)
        
        function obj = MatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function compute(obj)
            if obj.computeIfPassed()
                cprintf('comment',obj.matrixname);
                cprintf('comment',' matrix is correct!\n');
            else
                cprintf('err',obj.matrixname);
                cprintf('err',' matrix is wrong!\n');
            end
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.testedData  = cParams.tested;
            obj.testerData  = cParams.tester;
            obj.matrixname  = cParams.matrixname;
        end
        
        function passed = computeIfPassed(obj)
            maxdiff = obj.checkMaxDifference();
            tolerance = 1e-10;
            if maxdiff > tolerance
                passed = 0;
            else
                passed = 1;
            end
        end
        
        function maxdiff = checkMaxDifference(obj)
            diff    = abs(obj.testedData - obj.testerData)./obj.testerData;
            maxdiff = max(max(diff));
        end
    end
    
end