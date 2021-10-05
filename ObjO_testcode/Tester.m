classdef Tester < handle
    
    properties (Access = private) 
        matrixname
    end
    properties (Access = public)
        displacements
                u 
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
    
        function compute(obj)
            s.tester     = obj.displacements;
            s.tested     = obj.u;
            s.matrixname = obj.matrixname;
            TestDisplacements = MatrixTester(s);
            TestDisplacements.compute();
        end
        
        function obj = testFEM(obj,s)
            Femtest = FEMcomputer(s);
            Femtest.solve();
            obj.displacements = Femtest.displacement;
            obj.u             = Femtest.u;
            obj.matrixname    = 'Displacements';
            obj.compute();
        end
    end
end

