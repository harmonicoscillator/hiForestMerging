
#include <TChain.h>
#include <TFile.h>
#include <TString.h>
#include <iostream>

void mergeForest(TString fname = "/mnt/hadoop/cms/store/user/luck/test/*.root", TString outfile="output.root")
{
  TChain *dummyChain = new TChain("hiEvtAnalyzer/HiTree");
  dummyChain->Add(fname);
  TFile *testFile = dummyChain->GetFile();
  TList *topKeyList = testFile->GetListOfKeys();

  std::vector<TString> trees;
  std::vector<TString> dir;

  for(int i = 0; i < topKeyList->GetEntries(); ++i)
  {
    TDirectoryFile *dFile = (TDirectoryFile*)testFile->Get(topKeyList->At(i)->GetName());
    if(strcmp(dFile->ClassName(), "TDirectoryFile") != 0) continue;
    
    TList *bottomKeyList = dFile->GetListOfKeys();

    for(int j = 0; j < bottomKeyList->GetEntries(); ++j)
    {
      TString treeName = dFile->GetName();
      treeName += "/";
      treeName += bottomKeyList->At(j)->GetName();

      TTree* tree = (TTree*)testFile->Get(treeName);
      if(strcmp(tree->ClassName(), "TTree") != 0 && strcmp(tree->ClassName(), "TNtuple") != 0) continue;

      trees.push_back(treeName);
      dir.push_back(dFile->GetName());
    }
  }

  testFile->Close();
  delete dummyChain;
  
  // for(unsigned i = 0; i < trees.size(); ++i)
  // {
  //   std::cout<< trees.at(i) << std::endl;
  // }

  const int Ntrees = trees.size();
  
  TChain* ch[Ntrees];

  for(int i = 0; i < Ntrees; ++i){
    ch[i] = new TChain(trees[i]);
    ch[i]->Add(fname);
    std::cout<<"Tree loaded : " << trees[i] <<std::endl;
    std::cout<<"Entries : " << ch[i]->GetEntries() <<std::endl;
  }

  TFile* file = new TFile(outfile, "RECREATE");

  for(int i = 0; i < Ntrees; ++i){
    file->cd();
    std::cout << trees[i] <<std::endl;
    if (i==0) {
      file->mkdir(dir[i])->cd();
    } else {
      if ( dir[i] != dir[i-1] )
  	file->mkdir(dir[i])->cd();
      else
  	file->cd(dir[i]);
    }
    ch[i]->Merge(file,0,"keep");
  }
  std::cout <<"Done"<<std::endl;
  //file->Write();
  file->Close();

}

int main(int argc, char *argv[])
{
  if(argc != 3)
  {
    std::cout << "Usage: mergeForest <input_collection> <output_file>" << std::endl;
    return 1;
  }
  mergeForest(argv[1], argv[2]);
  return 0;
}
