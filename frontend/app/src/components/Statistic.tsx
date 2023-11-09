import React, { useState, useEffect } from "react";
import moment from "moment";
import DatePicker from "react-datepicker";

import { useQuery, useLazyQuery, gql } from "@apollo/client";
import "../scss/components/statistic.scss";
import "react-datepicker/dist/react-datepicker.css";

interface Props {
  repoId: number;
  repoOwner: string;
  repoName: string;
}

const STATISTIC_QUERY = gql`
  query (
    $repositoryName: String
    $repositoryOwner: String
    $fromDate: ISO8601Date
    $toDate: ISO8601Date
  ) {
    statistic(
      repositoryName: $repositoryName
      repositoryOwner: $repositoryOwner
      fromDate: $fromDate
      toDate: $toDate
    ) {
      year
      month
      user {
        id
        githubLogin
        avatarUrl
      }
      isOverall
      totalMergeTime
      averageMergeTime
      mergedPrCount
      approvalCount
    }
  }
`;

const padTimeNum = (num: number): string => {
  return num.toString().padStart(2, "0");
};
const seconds_to_formated_time = (seconds: number) => {
  const duration = moment.duration(seconds, "seconds");
  const days = Math.floor(duration.asDays());
  const hours = padTimeNum(duration.hours());
  const minutes = padTimeNum(duration.minutes());
  const sec = padTimeNum(duration.seconds());

  const formated_time = `${days}日 ${hours} : ${minutes} : ${sec}`;
  return formated_time;
};

export const Statistic = ({ repoId, repoOwner, repoName }: Props) => {
  const [inputDate, setInputDate] = useState<{
    fromDateInput: Date;
    toDateInput: Date;
  }>({
    fromDateInput: new Date("2023-01-01"),
    toDateInput: new Date("2023-12-01"),
  });

  const [fetchDate, setFetchDate] = useState<{
    fetchFromDate: Date;
    fetchToDate: Date;
  }>({
    fetchFromDate: inputDate.fromDateInput,
    fetchToDate: inputDate.toDateInput,
  });

  const [fetchData, { data, loading, error }] = useLazyQuery(STATISTIC_QUERY, {
    // network-only: Fetches data directly from the network on every query, bypassing cache.
    // otherwise, it will not query the data the second time the button is clicked
    fetchPolicy: "network-only",
    variables: {
      repositoryName: repoName,
      repositoryOwner: repoOwner,
      fromDate: fetchDate.fetchFromDate,
      toDate: fetchDate.fetchToDate,
    },
    onCompleted: (data) => {
      console.log("Data fetched:", data);
    },
    onError: (error) => {
      console.log("Error fetching data:", error);
    },
  });

  // Fetch data when the button is clicked
  const handleFetchClick = () => {
    console.log("handleFetchClick");

    fetchData();
    setFetchDate({
      fetchFromDate: inputDate.fromDateInput,
      fetchToDate: inputDate.toDateInput,
    });
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div className="statistic_component">
      <h3>-- 集計データ --</h3>
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error.message}</div>}
      <div className="date_input">
        <div className="inline">
          <span>From Date:</span>
          <DatePicker
            selected={inputDate.fromDateInput}
            onChange={(date: Date) => {
              console.log("from date---", date);
              setInputDate({
                ...inputDate,
                fromDateInput: date,
              });
            }}
            dateFormat="yyyy-MM"
            showMonthYearPicker
          />
        </div>
        <div className="inline">
          <span>To Date:</span>
          <DatePicker
            selected={inputDate.toDateInput}
            onChange={(date: Date) => {
              console.log("to date---", date);
              setInputDate({
                ...inputDate,
                toDateInput: date,
              });
            }}
            dateFormat="yyyy-MM"
            showMonthYearPicker
          />
        </div>
        <button className="button-grey" onClick={handleFetchClick}>
          取得
        </button>
      </div>
      {data && data.statistic && (
        <div className="stat_list">
          {data.statistic.map((stat: any, index: number) => (
            <div
              key={index}
              className={"stat_box ".concat(
                stat.isOverall ? "is_overall" : "not_overall"
              )}
            >
              <div className="stat_box_content">
                {stat.isOverall ? (
                  <h4>総データ</h4>
                ) : (
                  stat.user && (
                    <h4>
                      <span> ユーザ:</span>
                      {stat.user.githubLogin}
                    </h4>
                  )
                )}
                <div>
                  <span>MergeされたPRの数: </span>
                  {stat.mergedPrCount}
                </div>
                <div>
                  <span> Mergeの合計時間: </span>
                  {seconds_to_formated_time(stat.totalMergeTime)}
                </div>
                <div>
                  <span>Mergeの平均時間: </span>
                  {seconds_to_formated_time(stat.averageMergeTime)}
                </div>
                <div>
                  <div>{"-".repeat(30)} </div>
                  <span>ApproveしたPRの数: </span>
                  {stat.approvalCount}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
