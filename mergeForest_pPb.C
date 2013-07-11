
#include <TChain.h>
#include <TFile.h>
#include <TString.h>
#include <iostream>

void mergeForest_pPb(TString fname = "/mnt/hadoop/cms/store/user/richard/pA_photonSkimForest_v85_unmerged/pA_*", TString outfile="output.root")
{
     cout  << fname << endl;
     const Int_t Ntrees = 73;
     // const int Ntrees = 13;
   TString dir[Ntrees] = {
     "akPu2PFCones",   
     "akPu2PFCones",   
     "akPu3PFCones",   
     "akPu3PFCones",   
     "akPu4PFCones",   
     "akPu4PFCones",   
     "akPu5PFCones",   
     "akPu5PFCones",   
     "akPu2CaloCones", 
     "akPu2CaloCones", 
     "akPu3CaloCones", 
     "akPu3CaloCones", 
     "akPu4CaloCones", 
     "akPu4CaloCones", 
     "akPu5CaloCones", 
     "akPu5CaloCones", 
     "hltanalysis",    
     "skimanalysis",   
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "fastjet",
     "hcalNoise",
     "akPu3PFJetAnalyzer",
     "akPu4PFJetAnalyzer",
     "akPu5PFJetAnalyzer",
     "akPu3CaloJetAnalyzer",
     "akPu4CaloJetAnalyzer",
     "akPu5CaloJetAnalyzer",
     "ak3PFJetAnalyzer",
     "ak4PFJetAnalyzer",
     "ak5PFJetAnalyzer",
     "ak3CaloJetAnalyzer",
     "ak4CaloJetAnalyzer",
     "ak5CaloJetAnalyzer",
     "multiPhotonAnalyzer",
     "ppTrack",
     "pfcandAnalyzer",
     "anaMET",
     "muonTree",
     "hiEvtAnalyzer"
     //"HiForest", //only contains histos?
   };


   TString trees[Ntrees] = {
     "ntRandom0",        //"akPu2PFCones",   
     "ntRandom1",        //"akPu2PFCones",   
     "ntRandom0",        //"akPu3PFCones",   
     "ntRandom1",        //"akPu3PFCones",   
     "ntRandom0",        //"akPu4PFCones",   
     "ntRandom1",        //"akPu4PFCones",   
     "ntRandom0",        //"akPu5PFCones",   
     "ntRandom1",        //"akPu5PFCones",   
     "ntRandom0",        //"akPu2CaloCones", 
     "ntRandom1",        //"akPu2CaloCones", 
     "ntRandom0",        //"akPu3CaloCones", 
     "ntRandom1",        //"akPu3CaloCones", 
     "ntRandom0",        //"akPu4CaloCones", 
     "ntRandom1",        //"akPu4CaloCones", 
     "ntRandom0",        //"akPu5CaloCones", 
     "ntRandom1",        //"akPu5CaloCones", 
     "HltTree",	        //"hltanalysis",    
     "HltTree",	        //"skimanalysis",   
     // fastjet x36
     "ak1PFJets05",
     "ak2PFJets05",
     "ak3PFJets05",
     "ak4PFJets05",
     "ak5PFJets05",
     "ak6PFJets05",
     "ak1PFJets1",
     "ak2PFJets1",
     "ak3PFJets1",
     "ak4PFJets1",
     "ak5PFJets1",
     "ak6PFJets1",
     "ak1PFJets2",
     "ak2PFJets2",
     "ak3PFJets2",
     "ak4PFJets2",
     "ak5PFJets2",
     "ak6PFJets2",
     "kt1PFJets05",
     "kt2PFJets05",
     "kt3PFJets05",
     "kt4PFJets05",
     "kt5PFJets05",
     "kt6PFJets05",
     "kt1PFJets1",
     "kt2PFJets1",
     "kt3PFJets1",
     "kt4PFJets1",
     "kt5PFJets1",
     "kt6PFJets1",
     "kt1PFJets2",
     "kt2PFJets2",
     "kt3PFJets2",
     "kt4PFJets2",
     "kt5PFJets2",
     "kt6PFJets2",
     //end fastjet
     "hbhenoise",
     //jet trees x12
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     "t",
     //end jet trees
     "photon",
     "trackTree",
     "pfTree",
     "metTree",
     "HLTMuTree",
     "HiTree"
     // nothing for HiForest
   };


   TChain* ch[Ntrees];

   int N = Ntrees;

   for(int i = 0; i < N; ++i){
      ch[i] = new TChain(dir[i]+"/"+trees[i]);
      ch[i]->Add(fname);
      cout<<"Tree loaded : " << dir[i]+"/"+trees[i] <<endl;
      cout<<"Entries : " << ch[i]->GetEntries() <<endl;
   }

   TFile* file = new TFile(outfile, "RECREATE");

   for(int i = 0; i < N; ++i){
      file->cd();
      cout << dir[i]+"/"+trees[i] <<endl;
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
   cout <<"Done"<<endl;
   //file->Write();
   file->Close();

}


