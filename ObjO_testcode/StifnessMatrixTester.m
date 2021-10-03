classdef StifnessMatrixTester < handle
    
    properties (Access = private)
        Kglobal
        Kglobalt
    end
    
    
    methods (Access = public)
        
        function obj = StifnessMatrixTester(cParams)
            obj.init(cParams)           
        end
        
        function computeTest(obj)
            if obj.computeError()
                cprintf('comment','Stifness Matrix is correct!');
            else
                cprintf('err','Stifness Matrix is wrong!');
            end
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            load(cParams.stifnessmatrix);
            obj.Kglobal  = cParams.Kglobal;
            obj.Kglobalt = Kgt;
        end
        
        function passed = computeError(obj)
            maxdiff = obj.checkMaxDifference();
            tolerance = 1e-10;
            if maxdiff > tolerance
                passed = 0;
            else
                passed = 1;
            end
        end
        
        function maxdiff = checkMaxDifference(obj)
            diff = obj.Kglobal - obj.Kglobalt;
            maxdiff = max(diff);
        end
    end
    
end