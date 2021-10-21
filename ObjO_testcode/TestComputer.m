classdef TestComputer < handle
    
    properties (Access = protected)
        loadedData
        computedData
        testedPropertyName
    end
    
    
    methods (Access = public)
        
        function obj = TestComputer()
            
        end
        
    end
    
    methods (Access = protected)
        
        function checkResult(obj)

            if obj.check()
                cprintf('comment',obj.testedPropertyName);
                cprintf('comment',' is correct!\n');
            else
                cprintf('err',obj.testedPropertyName);
                cprintf('err',' is wrong!\n');
            end
        end
        
    end
    
    methods (Access = private)
        
        function passed = check(obj)
            maxdiff   = obj.computeMaxDifference();
            tolerance = 1e-8;
            if maxdiff > tolerance
                passed = 0;
            else
                passed = 1;
            end
        end
        
        function maxdiff = computeMaxDifference(obj)
            diff    = obj.computeDifference();
            maxdiff = max(max(diff));
        end
        
        function diff = computeDifference(obj)
            diff = abs((obj.computedData - obj.loadedData)...
                ./obj.loadedData);
        end
        
    end
    
end