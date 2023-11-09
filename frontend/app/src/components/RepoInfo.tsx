import { useQuery, gql } from "@apollo/client";

import "../scss/components/repoInfo.scss";

// *unfinished: need to be refine here
// const owner = "Nekoiii";
// const owner = "Nekoiii2";
// const repoName = "Rails_Tutorial";

interface Props {
  repoId: number;
  repoOwner: string;
  repoName: string;
}

// '!' after 'ID' means not null
const REPO_INFO_QUERY_BY_ID = gql`
  query ($id: ID!) {
    repositoryInfo(id: $id) {
      name
      description
      url
      githubCreatedAt
    }
  }
`;
const REPO_INFO_QUERY = gql`
  query ($name: String, $ownerGithubLogin: String) {
    repositoryInfo(name: $name, ownerGithubLogin: $ownerGithubLogin) {
      name
      description
      url
      githubCreatedAt
    }
  }
`;

export const RepoInfo = ({ repoId, repoOwner, repoName }: Props) => {
  const { data, loading, error } = useQuery(REPO_INFO_QUERY, {
    // variables: { id: repoId },
    variables: { name: repoName, ownerGithubLogin: repoOwner },
  });
  console.log("RepoInfo--Data:", data);

  return (
    <div className="repo_info">
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error.message}</div>}
      {data && data.repositoryInfo && (
        <div>
          <h3>-- レポシトリー情報 --</h3>
          <div className="flex flex-column ">
            <div>レポシトリー名: {data.repositoryInfo.name}</div>
            {data.repositoryInfo.description && (
              <div>Description: {data.repositoryInfo.description}</div>
            )}
            <div className="font-small">
              作成時期: {data.repositoryInfo.githubCreatedAt}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
