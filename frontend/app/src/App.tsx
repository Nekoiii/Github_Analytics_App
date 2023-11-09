import React, { useState } from "react";

import logo from "./logo.svg";
import "./App.scss";
import "./scss/variables.scss";
import "./scss/style.scss";
import "./scss/frequently_used.scss";

import { ApolloClient, InMemoryCache, ApolloProvider } from "@apollo/client";
import { RepoInfo } from "./components/RepoInfo";
import { Statistic } from "./components/Statistic";

const client = new ApolloClient({
  uri: "http://localhost:3001/graphql",
  cache: new InMemoryCache(),
});

function App() {
  const repoId = 1; //* unfinished, 'repoId: 1' for test
  const repoOwner = "Nekoiii";
  const repoName = "Rails_Tutorial";

  return (
    <ApolloProvider client={client}>
      <RepoInfo repoId={repoId} repoOwner={repoOwner} repoName={repoName} />
      <Statistic repoId={repoId} repoOwner={repoOwner} repoName={repoName} />
    </ApolloProvider>
  );
}

export default App;
