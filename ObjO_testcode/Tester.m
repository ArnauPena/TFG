classdef Tester
    
    properties (Access = private)
        passed
        u
        displacements  
    end
    
    methods (Access = public)
        function obj = tester(staticFileData)
            cParams = FEMcomputer(staticFileData);
            obj.u = cParams.u;
            obj.displacements = cParams.displacement;
        end
    
        function check(staticCase)
            if abs(staticCase.u-staticCase.displacement)/staticCase.displacement < 1e-10
                cprintf('comment','Code is correct!');
            else
                cprintf('err','Something is wrong!');
            end
        end
    end
end

