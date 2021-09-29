classdef SystemSolution < handle
    
    properties (Access = public)
        vr,vl
        ul,ur 
        Rr
        u
        Kll, Krr, Krl, Klr
        Fr, Fl
    end
    
    methods
        function obj = SystemSolution(cParams)
            obj.systemSolver(cParams);
        end
        
        function obj = systemSolver(obj,cParams)
            
            e = PartComputer(cParams);
            e.computePart(); 
            obj.vl = e.vl;
            obj.vr = e.vr;
            obj.ur = e.ur;
            s.vl = e.vl;
            s.vr = e.vl;
            s.ur = e.ur;
            s.Kll = e.Kll;
            s.Krr = e.Krr;
            s.Krl = e.Krl;
            s.Klr = e.Klr;
            s.Fr = e.Fr;
            s.Fl = e.Fl;
            
            
            f = DirectSolver(s);
            f.computeSolver();
            obj.Rr = f.Rr;
            obj.ul = f.ul;
            
            obj.u(obj.vl,1) = obj.ul;
            obj.u(obj.vr,1) = obj.ur;
            
            
            
        end
    end
end

