defmodule Mds.QuestionsTest do
  use Mds.DataCase

  alias Mds.Questions

  describe "questions" do
    alias Mds.Questions.Question

    @valid_attrs %{title: "some title", body: "Some body"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    test "list_questions/0 returns all questions" do
      question = Mds.Fixtures.fixture(:question)
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = Mds.Fixtures.fixture(:question)
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Questions.create_question(@valid_attrs)
      assert question.title == "some title"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = Mds.Fixtures.fixture(:question)
      assert {:ok, %Question{} = question} = Questions.update_question(question, @update_attrs)
      assert question.title == "some updated title"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = Mds.Fixtures.fixture(:question)
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = Mds.Fixtures.fixture(:question)
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = Mds.Fixtures.fixture(:question)
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
