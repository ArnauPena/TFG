classdef ConnectivityMatrix < handle
    
    properties (Access = public)
        td
    end
    
    properties (Access = private)
        dim
        data
    end
    
    methods (Access = public)
        
        function obj = ConnectivityMatrix(cParams)
                obj.init(cParams);
        end
        
        function obj = computeConnectivityMatrix(obj)
            nel = obj.dim.nel;
            ni  = obj.dim.ni;
            nne = obj.dim.nne;
            vtd = zeros(nel,nne*ni);
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        vtd(e,I)= ni*(obj.data.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.td = vtd;
        end
       
        
    end
    
    methods (Access = private)
        
        function obj = init(obj,cParams)
            obj.dim  = cParams.dim;
            obj.data = cParams.data;
        end
        
    end
end

