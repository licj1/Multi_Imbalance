function prediction=execute(traindata,trainclass,gamma)



%%%%%%%%%%%%%%%%%// working on training
trainRealClass = zeros(length(trainclass),1);
trainPrediction = zeros(length(trainclass),1);
         
for i = 1:length(trainclass)
    %% // true class
    trainRealClass(i,1) = trainclass(i);
    % %     //////////////////////////////////////////////
    % %     // predicted class with the IFROWANN method //
    % %     //////////////////////////////////////////////
    %ArrayList<Double> lowerPos = new ArrayList<Double>(); //1-sim for elements in negClass
    %ArrayList<Double> lowerNeg = new ArrayList<Double>(); //1-sim for elements in posClass
    nlowerPos=1;
    nlowerNeg=1
    for x = 1:length(trainclass)
        if trainclass(x) == posID
            lowerNeg(nlowerNeg)=1.0 - similarity(traindata(x,:), traindata(i,:));
            nlowerNeg=nlowerNeg+1;
        else trainclass(x) == negID
            lowerPos(nlowerPos)=1.0 - similarity(traindata(x,:), traindata(i,:));
            nlowerPos=nlowerPos+1;
        end
    end
    
    lowerPos=sort(lowerPos,'descend');
    lowerNeg=sort(lowerNeg,'descend');
    
    %%%%// get OWA weights
   
    if strcmpi(weightStrategy,'W1')
        OWAweightspos = additive(length(lowerPos));
        OWAweightsneg = additive(length(lowerNeg));
    else if strcmpi(weightStrategy,'W2')
            OWAweightspos = additive(length(lowerPos));
            OWAweightsneg = exponential(length(lowerNeg));
        else if strcmpi(weightStrategy,'W3')
                OWAweightspos = exponential(length(lowerPos));
                OWAweightsneg = additive(length(lowerNeg));
            else if strcmpi(weightStrategy,'W4') 
                    OWAweightspos = exponential(length(lowerPos));
                    OWAweightsneg = exponential(length(lowerNeg));
                else if strcmpi(weightStrategy,'W5')
                        OWAweightspos = additive_gamma(length(lowerPos), length(lowerNeg),gamma);
                        OWAweightsneg = additive(length(lowerNeg));
                    else if strcmpi(weightStrategy,'W6') 
                            OWAweightspos = additive_gamma(length(lowerPos), length(lowerNeg),gamma);
                            OWAweightsneg = exponential(length(lowerNeg));
                        end
                    end
                end
            end
        end
    end
    
    sumPos = 0.0;
    for el = 1:length(lowerPos)
        sumPos = sumPos + OWAweightspos(el) * lowerPos(el);
    end
    
    sumNeg = 0.0;
    for el = 1:length(lowerNeg)
        sumNeg = sumNeg + OWAweightsneg(el) * lowerNeg(el);
    end
    
    if sumPos >= sumNeg
        trainPrediction(i,1) = posID;
    else
        trainPrediction(i,1) = negID;
    end
end
    %%%%%%%%%%%%%%%%%%%KNN.writeOutput(ficheroSalida[0], trainRealClass, trainPrediction,  entradas, salida, relation);


%%%%%%%%//Working on test
[testlength,testa]=size(testdata);
realClass = zeros(testlength,1);
prediction = zeros(testlength,1);

for i = 1:length(realClass)
    %%  true class
    realClass(i,1) = testclass(i);
    % %     //////////////////////////////////////////////
    % %     // predicted class with the IFROWANN method //
    % %     //////////////////////////////////////////////
    %ArrayList<Double> lowerPos = new ArrayList<Double>(); //1-sim for elements in negClass
    %ArrayList<Double> lowerNeg = new ArrayList<Double>(); //1-sim for elements in posClass
    nlowerPos=1;
    nlowerNeg=1
    for x = 1:length(trainclass)
        if trainclass(x) == posID
            lowerNeg(nlowerNeg)=1.0 - similarity(traindata(x,:), testdata(i,:));
            nlowerNeg=nlowerNeg+1;
        else trainclass(x) == negID
            lowerPos(nlowerPos)=1.0 - similarity(traindata(x,:), testdata(i,:));
            nlowerPos=nlowerPos+1;
        end
    end
    
    lowerPos=sort(lowerPos,'descend');
    lowerNeg=sort(lowerNeg,'descend');
    
    %%%%// get OWA weights
   
    if strcmpi(weightStrategy,'W1')
        OWAweightspos = additive(length(lowerPos));
        OWAweightsneg = additive(length(lowerNeg));
    else if strcmpi(weightStrategy,'W2')
            OWAweightspos = additive(length(lowerPos));
            OWAweightsneg = exponential(length(lowerNeg));
        else if strcmpi(weightStrategy,'W3')
                OWAweightspos = exponential(length(lowerPos));
                OWAweightsneg = additive(length(lowerNeg));
            else if strcmpi(weightStrategy,'W4') 
                    OWAweightspos = exponential(length(lowerPos));
                    OWAweightsneg = exponential(length(lowerNeg));
                else if strcmpi(weightStrategy,'W5')
                        OWAweightspos = additive_gamma(length(lowerPos), length(lowerNeg),gamma);
                        OWAweightsneg = additive(length(lowerNeg));
                    else if strcmpi(weightStrategy,'W6') 
                            OWAweightspos = additive_gamma(length(lowerPos), length(lowerNeg),gamma);
                            OWAweightsneg = exponential(length(lowerNeg));
                        end
                    end
                end
            end
        end
    end
    
    sumPos = 0.0;
    for el = 1:length(lowerPos)
        sumPos = sumPos + OWAweightspos(el) * lowerPos(el);
    end
    
    sumNeg = 0.0;
    for el = 1:length(lowerNeg)
        sumNeg = sumNeg + OWAweightsneg(el) * lowerNeg(el);
    end
    
    if sumPos >= sumNeg
        prediction(i,1) = posID;
    else
        prediction(i,1) = negID;
    end
end
        

  %%%%%%%%%%%%%%%%%%     KNN.writeOutput(ficheroSalida[1], realClass, prediction,  entradas, salida, relation);   