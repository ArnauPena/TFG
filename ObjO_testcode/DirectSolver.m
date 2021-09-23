classdef DirectSolver < handle
    
    properties (Access = public)
        Rr
        ul
        Kll, Krr
        Klr, Krl
        Fl, Fr
        ur
    end
    
    methods (Access = public)
        function obj = DirectSolver(cParams)
            obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.Kll = cParams.Kll;
            obj.Krr = cParams.Krr;
            obj.Klr = cParams.Klr;
            obj.Krl = cParams.Krl;
            obj.Fl = cParams.Fl;
            obj.ur = cParams.ur;    
            obj.Fr = cParams.Fr;
        end
    end
    methods (Access = public)
        function obj = computeSolver(obj)
            uls = obj.Kll\(obj.Fl-obj.Klr*obj.ur);
            Rrs= obj.Krr*obj.ur+obj.Krl*uls-obj.Fr;
            
            obj.ul = uls;
            obj.Rr = Rrs;
        end
    end
end

