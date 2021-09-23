classdef StifnessMatrixComputer < handle
    
    properties
        Td
        R
        K
        Kg
    end
    
    methods
        function obj = StifnessMatrixComputer(s)
                obj.computeStifnessMatrix();
        end
        
        
        function [Td,R,K,Kg] = computeStifnessMatrix(obj,cParams)
            
                a = ConnectionMatrix(cParams);
                a.computeConnectionMatrix();
                obj.Td = a.td;
                
                b = RotationMatrix(cParams);
                R = b.r;
                
                c = Kcomputer(cParams);
                K = c.k;
                
                d = KglobalAssembler(cParams);
                Kg = d.kg;
                   
        end
    end
end

