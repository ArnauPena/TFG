classdef PartComputer < handle
    
    properties (Access = public)
        vr,vl,ur
        Kll,Krr,Krl,Klr
        Fl, Fr
        dim, data
        Kglobal
        Fext
    end
    
    methods
        function obj = PartComputer(cParams)
            obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
            obj.Kglobal = cParams.Kglobal;
            obj.Fext = cParams.Fext;
        end
    
        
        function obj = computePart(obj)
            fNode = obj.data.fixNode;
            Kg = obj.Kglobal;
            vrs=size(fNode,1);
            urs=size(fNode,1);
            
            for k = 1:size(fNode,1)
                Node = fNode(k,1); 
                DOF = fNode(k,2); 
                Displacement = fNode(k,3); 
                if DOF==1
                    vrs(k,1) = 3*Node-2;
                end
                if DOF==2
                    vrs(k,1) = 3*Node-1;
                end
                if DOF==3
                    vrs(k,1) = 3*Node;
                end
                urs(k,1)=Displacement;
            end
            j=[1:obj.dim.ndof].';
            vls=j;
            for k = 1:obj.dim.ndof
                Fixed = any(vrs(:) == j(k));
                if Fixed
                    vls(k)=0;
                end
            end
            vls(vls==0)=[];
            
            Klls=Kg(vls,vls);
            Krrs=Kg(vrs,vrs);
            Krls=Kg(vrs,vls);
            Klrs=Kg(vls,vrs);
            
            Frs=size(vrs,1); 
            Fls=size(vls,1);
            
            for i=1:length(vrs)
                Frs(i,1)=obj.Fext(vrs(i));
            end
            for i=1:length(vls)
                Fls(i,1)=obj.Fext(vls(i));
            end
            
            obj.vl = vls;
            obj.vr = vrs;
            obj.ur = urs;
            obj.Kll = Klls;
            obj.Krr = Krrs;
            obj.Krl = Krls;
            obj.Klr = Klrs;
            obj.Fr = Frs;
            obj.Fl = Fls;
        end
    end
end

