class MavenAntTasks < Formula
  desc "Maven tasks for Apache Ant"
  homepage "https://maven.apache.org/components/ant-tasks/"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/ant-tasks/2.1.3/binaries/maven-ant-tasks-2.1.3.jar"
  sha256 "f16b5ea711dfe0323454b880180aa832420ec039936e4aa75fb978748634808a"

  bottle :unneeded

  depends_on "ant"

  def install
    (share+"ant").install "maven-ant-tasks-2.1.3.jar"
  end

  test do
    (testpath/"build.xml").write <<-EOS.undent
      <project name="HomebrewTest" default="init" basedir="."
          xmlns:artifact="antlib:org.apache.maven.artifact.ant">
        <target name="init">
           <artifact:dependencies filesetId="dependency.fileset">
             <localRepository path="#{testpath}/.m2" />
             <dependency groupId="junit" artifactId="junit" version="4.12" scope="test"/>
           </artifact:dependencies>

           <restrict id="filtered.fileset">
             <fileset refid="dependency.fileset"/>
             <name name="**/junit-4.12.jar"/>
           </restrict>

           <condition property="junit.exists" value="yes">
             <resourcecount when="greater" count="0" refid="filtered.fileset" />
           </condition>

           <fail unless="junit.exists" message="Failed to download maven artifacts!"/>
           <echo message="Test passes!"/>
        </target>
      </project>
    EOS
    system Formula["ant"].opt_bin/"ant"
  end
end
