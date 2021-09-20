classdef StifnessMatrixComputer
    
    properties
        Td
        Kel
        R
        K
    end
    
    methods
        function obj = StifnessMatrixComputer()
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function obj = computeStifnessMatrix(obj)
                a = ConnectionMatrix();
                obj.Td = a.td;
                b = RotationMatrix();
                obj.R = b.r;
                c = c.K;
                

            
        end
    end
end

