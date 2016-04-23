INFERANALYZE= /usr/local/Cellar/infer/0.7.0/libexec/infer/lib/python/inferlib/../../../bin/InferAnalyze $(INFER_OPTIONS) -results_dir '/Users/wenghengcong/Github/Coderpursue/Coderpursue/infer-out'

OBJECTS=cl1 cl2 cl3 cl4 cl5 cl6 cl7 cl8 cl9 cl10 cl11 cl12 cl13 cl14 cl15 cl16 cl17 cl18 cl19 

default: test

all: test

test: $(OBJECTS)
	echo ""
cl1 : 
	$(INFERANALYZE) -cluster xcl1.cluster >cl1

cl2 : 
	$(INFERANALYZE) -cluster xcl2.cluster >cl2

cl3 : 
	$(INFERANALYZE) -cluster xcl3.cluster >cl3

cl4 : 
	$(INFERANALYZE) -cluster xcl4.cluster >cl4

cl5 : 
	$(INFERANALYZE) -cluster xcl5.cluster >cl5

cl6 : cl5
	$(INFERANALYZE) -cluster xcl6.cluster >cl6

cl7 : cl3 cl5 cl6
	$(INFERANALYZE) -cluster xcl7.cluster >cl7

cl8 : cl4 cl5 cl6
	$(INFERANALYZE) -cluster xcl8.cluster >cl8

cl9 : cl3 cl4 cl5 cl6 cl8
	$(INFERANALYZE) -cluster xcl9.cluster >cl9

cl10 : cl3 cl5 cl6
	$(INFERANALYZE) -cluster xcl10.cluster >cl10

cl11 : cl5 cl6
	$(INFERANALYZE) -cluster xcl11.cluster >cl11

cl12 : cl5 cl6
	$(INFERANALYZE) -cluster xcl12.cluster >cl12

cl13 : cl6
	$(INFERANALYZE) -cluster xcl13.cluster >cl13

cl14 : cl6
	$(INFERANALYZE) -cluster xcl14.cluster >cl14

cl15 : cl5 cl6 cl14
	$(INFERANALYZE) -cluster xcl15.cluster >cl15

cl16 : cl5 cl6 cl14
	$(INFERANALYZE) -cluster xcl16.cluster >cl16

cl17 : cl5 cl6
	$(INFERANALYZE) -cluster xcl17.cluster >cl17

cl18 : cl5 cl6 cl17
	$(INFERANALYZE) -cluster xcl18.cluster >cl18

cl19 : cl5 cl6 cl17
	$(INFERANALYZE) -cluster xcl19.cluster >cl19


clean:
	rm -f $(OBJECTS)
